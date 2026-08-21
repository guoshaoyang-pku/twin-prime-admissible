import Sound
import lean_certs.cert_19_48

open CertVerify

theorem H19_gt_48 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 19) (d := 48) (c := cert_19_48) (by native_decide)
