import Sound
import lean_certs.cert_43_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_168_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 43) (d := 168) (c := cert_43_168) (by decide)
