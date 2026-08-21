import Sound
import lean_certs.cert_45_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_94_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 45) (d := 94) (c := cert_45_94) (by decide)
