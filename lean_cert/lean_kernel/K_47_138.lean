import Sound
import lean_certs.cert_47_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_138_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 47) (d := 138) (c := cert_47_138) (by decide)
