import Sound
import lean_certs.cert_47_216

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_216_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 216 := by
  exact certValidRoot_sound (k := 47) (d := 216) (c := cert_47_216) (by decide)
