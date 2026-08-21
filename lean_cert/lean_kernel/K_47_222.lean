import Sound
import lean_certs.cert_47_222

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_222_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 222 := by
  exact certValidRoot_sound (k := 47) (d := 222) (c := cert_47_222) (by decide)
