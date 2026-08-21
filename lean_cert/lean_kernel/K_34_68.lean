import Sound
import lean_certs.cert_34_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_68_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 34) (d := 68) (c := cert_34_68) (by decide)
