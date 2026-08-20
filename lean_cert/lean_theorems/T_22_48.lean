import Sound
import lean_certs.cert_22_48

open CertVerify

theorem H22_gt_48 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 22) (d := 48) (c := cert_22_48) (by native_decide)
