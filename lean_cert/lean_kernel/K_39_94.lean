import Sound
import lean_certs.cert_39_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_94_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 39) (d := 94) (c := cert_39_94) (by decide)
