import Sound
import lean_certs.cert_47_188

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_188_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 47) (d := 188) (c := cert_47_188) (by decide)
