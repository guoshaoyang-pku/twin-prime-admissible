import Sound
import lean_certs.cert_15_48

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_48_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 15) (d := 48) (c := cert_15_48) (by decide)
