import Sound
import lean_certs.cert_26_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_94_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 26) (d := 94) (c := cert_26_94) (by decide)
