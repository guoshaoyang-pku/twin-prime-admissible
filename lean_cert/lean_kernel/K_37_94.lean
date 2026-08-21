import Sound
import lean_certs.cert_37_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_94_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 37) (d := 94) (c := cert_37_94) (by decide)
