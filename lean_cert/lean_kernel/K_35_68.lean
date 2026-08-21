import Sound
import lean_certs.cert_35_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_68_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 35) (d := 68) (c := cert_35_68) (by decide)
