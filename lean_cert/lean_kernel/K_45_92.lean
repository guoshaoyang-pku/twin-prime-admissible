import Sound
import lean_certs.cert_45_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_92_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 45) (d := 92) (c := cert_45_92) (by decide)
