import Sound
import lean_certs.cert_45_188

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_188_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 45) (d := 188) (c := cert_45_188) (by decide)
