import Sound
import lean_certs.cert_47_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_132_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 47) (d := 132) (c := cert_47_132) (by decide)
