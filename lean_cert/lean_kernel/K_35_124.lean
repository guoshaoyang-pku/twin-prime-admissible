import Sound
import lean_certs.cert_35_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_124_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 35) (d := 124) (c := cert_35_124) (by decide)
