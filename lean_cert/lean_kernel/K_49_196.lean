import Sound
import lean_certs.cert_49_196

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_196_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 49) (d := 196) (c := cert_49_196) (by decide)
