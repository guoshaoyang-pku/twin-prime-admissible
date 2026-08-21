import Sound
import lean_certs.cert_45_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_158_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 45) (d := 158) (c := cert_45_158) (by decide)
