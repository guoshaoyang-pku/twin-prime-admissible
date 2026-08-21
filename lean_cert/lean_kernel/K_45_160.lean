import Sound
import lean_certs.cert_45_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_160_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 45) (d := 160) (c := cert_45_160) (by decide)
