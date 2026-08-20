import Sound
import lean_certs.cert_23_48

open CertVerify

theorem H23_gt_48 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 23) (d := 48) (c := cert_23_48) (by native_decide)
