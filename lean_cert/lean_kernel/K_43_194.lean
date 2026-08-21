import Sound
import lean_certs.cert_43_194

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H43_gt_194_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 43) (d := 194) (c := cert_43_194) (by decide)
