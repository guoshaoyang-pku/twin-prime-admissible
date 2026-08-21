import Sound
import lean_certs.cert_43_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_144_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 43) (d := 144) (c := cert_43_144) (by decide)
