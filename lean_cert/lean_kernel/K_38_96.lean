import Sound
import lean_certs.cert_38_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_96_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 38) (d := 96) (c := cert_38_96) (by decide)
