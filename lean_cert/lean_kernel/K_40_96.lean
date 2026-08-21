import Sound
import lean_certs.cert_40_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_96_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 40) (d := 96) (c := cert_40_96) (by decide)
