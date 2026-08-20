import Sound
import lean_certs.cert_20_46

open CertVerify

theorem H20_gt_46 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 20) (d := 46) (c := cert_20_46) (by native_decide)
