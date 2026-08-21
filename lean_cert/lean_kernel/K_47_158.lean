import Sound
import lean_certs.cert_47_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_158_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 47) (d := 158) (c := cert_47_158) (by decide)
