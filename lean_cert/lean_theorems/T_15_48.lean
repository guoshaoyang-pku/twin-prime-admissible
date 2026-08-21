import Sound
import lean_certs.cert_15_48

open CertVerify

theorem H15_gt_48 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 15) (d := 48) (c := cert_15_48) (by native_decide)
