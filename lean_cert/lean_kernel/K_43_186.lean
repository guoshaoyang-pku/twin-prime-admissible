import Sound
import lean_certs.cert_43_186

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H43_gt_186_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 43) (d := 186) (c := cert_43_186) (by decide)
