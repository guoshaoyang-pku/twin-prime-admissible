import Sound
import lean_certs.cert_47_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_116_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 47) (d := 116) (c := cert_47_116) (by decide)
