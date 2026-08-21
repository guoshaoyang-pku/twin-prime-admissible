import Sound
import lean_certs.cert_48_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_94_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 48) (d := 94) (c := cert_48_94) (by decide)
