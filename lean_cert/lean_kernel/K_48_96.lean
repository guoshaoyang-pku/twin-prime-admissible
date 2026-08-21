import Sound
import lean_certs.cert_48_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_96_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 48) (d := 96) (c := cert_48_96) (by decide)
