import Sound
import lean_certs.cert_34_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_124_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 34) (d := 124) (c := cert_34_124) (by decide)
