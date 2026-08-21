import Sound
import lean_certs.cert_20_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_68_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 20) (d := 68) (c := cert_20_68) (by decide)
