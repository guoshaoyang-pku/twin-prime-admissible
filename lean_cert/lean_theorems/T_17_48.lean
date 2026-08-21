import Sound
import lean_certs.cert_17_48

open CertVerify

theorem H17_gt_48 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 17) (d := 48) (c := cert_17_48) (by native_decide)
