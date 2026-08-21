import Sound
import lean_certs.cert_45_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_164_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 45) (d := 164) (c := cert_45_164) (by decide)
