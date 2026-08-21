import Sound
import lean_certs.cert_45_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_124_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 45) (d := 124) (c := cert_45_124) (by decide)
