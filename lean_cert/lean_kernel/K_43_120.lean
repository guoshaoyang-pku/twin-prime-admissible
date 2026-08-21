import Sound
import lean_certs.cert_43_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_120_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 43) (d := 120) (c := cert_43_120) (by decide)
