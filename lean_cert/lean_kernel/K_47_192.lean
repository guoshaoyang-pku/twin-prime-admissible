import Sound
import lean_certs.cert_47_192

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_192_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 47) (d := 192) (c := cert_47_192) (by decide)
