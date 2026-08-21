import Sound
import lean_certs.cert_46_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_158_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 46) (d := 158) (c := cert_46_158) (by decide)
