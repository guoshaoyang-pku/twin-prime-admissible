import Sound
import lean_certs.cert_15_30

open CertVerify

theorem H15_gt_30 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 15) (d := 30) (c := cert_15_30) (by native_decide)
