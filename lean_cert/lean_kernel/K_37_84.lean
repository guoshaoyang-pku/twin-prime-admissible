import Sound
import lean_certs.cert_37_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_84_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 37) (d := 84) (c := cert_37_84) (by decide)
