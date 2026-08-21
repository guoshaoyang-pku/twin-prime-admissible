import Sound
import lean_certs.cert_31_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_94_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 31) (d := 94) (c := cert_31_94) (by decide)
