import Sound
import lean_certs.cert_43_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_150_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 43) (d := 150) (c := cert_43_150) (by decide)
