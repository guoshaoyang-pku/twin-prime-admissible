import Sound
import lean_certs.cert_47_196

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_196_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 47) (d := 196) (c := cert_47_196) (by decide)
