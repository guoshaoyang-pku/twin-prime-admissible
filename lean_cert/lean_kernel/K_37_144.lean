import Sound
import lean_certs.cert_37_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_144_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 37) (d := 144) (c := cert_37_144) (by decide)
