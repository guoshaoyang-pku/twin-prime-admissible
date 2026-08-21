import Sound
import lean_certs.cert_47_190

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_190_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 47) (d := 190) (c := cert_47_190) (by decide)
