import Sound
import lean_certs.cert_45_196

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H45_gt_196_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 45) (d := 196) (c := cert_45_196) (by decide)
