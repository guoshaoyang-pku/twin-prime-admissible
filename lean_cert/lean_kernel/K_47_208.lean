import Sound
import lean_certs.cert_47_208

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_208_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 47) (d := 208) (c := cert_47_208) (by decide)
