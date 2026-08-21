import Sound
import lean_certs.cert_38_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_144_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 38) (d := 144) (c := cert_38_144) (by decide)
