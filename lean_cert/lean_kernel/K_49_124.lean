import Sound
import lean_certs.cert_49_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_124_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 49) (d := 124) (c := cert_49_124) (by decide)
