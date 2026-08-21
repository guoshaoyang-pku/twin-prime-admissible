import Sound
import lean_certs.cert_47_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_122_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 47) (d := 122) (c := cert_47_122) (by decide)
