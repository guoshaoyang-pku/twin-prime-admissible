import Sound
import lean_certs.cert_43_190

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H43_gt_190_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 43) (d := 190) (c := cert_43_190) (by decide)
