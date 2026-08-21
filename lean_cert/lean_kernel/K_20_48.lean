import Sound
import lean_certs.cert_20_48

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_48_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 20) (d := 48) (c := cert_20_48) (by decide)
