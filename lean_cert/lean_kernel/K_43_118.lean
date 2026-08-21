import Sound
import lean_certs.cert_43_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_118_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 43) (d := 118) (c := cert_43_118) (by decide)
